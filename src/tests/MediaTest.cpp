#include <QCoreApplication>
#include <QTimer>
#include <QDebug>
#include <cassert>
#include "RadioTuner.h"
#include "MediaLibrary.h"

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    
    qDebug() << "========================================";
    qDebug() << "Starting Media Feature Verification Test";
    qDebug() << "========================================";

    // 1. RadioTuner Verification
    qDebug() << "[TEST] RadioTuner correctness...";
    RadioTuner tuner;
    
    // Test Initial State
    if (tuner.band() != RadioTuner::BandFM) return 1;
    if (tuner.frequency() != 8750) return 2;
    
    // Test Tuning
    tuner.tuneToString("98.3"); // Should be 9830
    if (tuner.frequency() != 9830) {
        qCritical() << "Radio Tuning Failed. Expected 9830, got" << tuner.frequency();
        return 3;
    }
    qDebug() << "  -> Tuned to 98.3 MHz successfully (Integer: 9830)";

    // Test Step
    tuner.stepUp(); // 9830 + 10 = 9840
    if (tuner.frequency() != 9840) return 4;
    qDebug() << "  -> Step Up success (98.4 MHz)";
    
    // Test Wrapping/Clamping
    tuner.tuneTo(10810); // 108.1 -> Should wrap to 87.5 (8750)
    if (tuner.frequency() != 8750) {
        qCritical() << "Radio Wrap Failed. Expected 8750, got" << tuner.frequency();
        return 5;
    }
    qDebug() << "  -> Frequency Wrapping success";


    // 2. MediaLibrary Verification
    qDebug() << "[TEST] MediaLibrary Async Scan...";
    MediaLibrary lib;
    
    // Expect indexing to start
    // We need to run event loop to allow QtConcurrent to finish
    // We will use a timer to timeout if it takes too long
    
    QTimer userTimeout;
    userTimeout.setSingleShot(true);
    QObject::connect(&userTimeout, &QTimer::timeout, &app, [&](){
        qCritical() << "TIMEOUT: Media scan took too long.";
        app.exit(10);
    });
    userTimeout.start(5000); // 5s timeout

    QObject::connect(&lib, &MediaLibrary::libraryUpdated, &app, [&](){
        qDebug() << "  -> Library scan finished signal received.";
        
        // Check results
        int count = lib.model()->rowCount();
        qDebug() << "  -> Found" << count << "tracks.";
        
        if (count == 0) {
            qCritical() << "Library empty! Expected mock data at least.";
            app.exit(11);
            return;
        }

        // 3. Search Verification
        qDebug() << "[TEST] Search functionality...";
        lib.search("Weeknd");
        int results = lib.searchResultsModel()->rowCount();
        qDebug() << "  -> Search 'Weeknd' found" << results << "results.";
        
        if (results == 0) {
             qCritical() << "Search failed.";
             app.exit(12);
             return;
        }
        
        // 4. Persistence Verification
        // Toggle like on first track
        lib.toggleLike(0);
        if (!lib.isLiked(0)) {
            qCritical() << "Like persistence failed.";
            app.exit(13);
            return;
        }
        qDebug() << "  -> Like toggled verification success.";

        qDebug() << "========================================";
        qDebug() << "ALL TESTS PASSED";
        app.exit(0);
    });

    return app.exec();
}
