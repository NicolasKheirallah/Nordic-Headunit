#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include <QQuickStyle>
#include <QQuickWindow>

#include "src/SystemSettings.h"
#include "src/HAL/SimulatedVehicleHAL.h"
#include "src/HAL/SimulatedAudioHAL.h"
#include "src/VehicleService.h"
#include "src/MediaService.h"
#include "src/NavigationService.h"
#include "src/PhoneService.h"
#include "src/PhoneService.h"
#include "src/LayoutService.h"
#include "src/TranslationService.h"
#include <QQmlContext>
#include <QThread>

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Basic");
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    
    // -------------------------------------------------------------------------
    // Hardware Abstraction Layer (HAL) Initialization
    // -------------------------------------------------------------------------
    
    // Create Threads
    QThread *vehicleThread = new QThread();
    QThread *audioThread = new QThread();
    
    // 1. Vehicle HAL
    // Create without parent so we can move to thread
    SimulatedVehicleHAL *vehicleHal = new SimulatedVehicleHAL(nullptr);
    vehicleHal->moveToThread(vehicleThread);
    
    // Clean up when thread finishes
    QObject::connect(vehicleThread, &QThread::finished, vehicleHal, &QObject::deleteLater);
    
    // Start Thread
    vehicleThread->start();

    // 2. Audio HAL
    SimulatedAudioHAL *audioHal = new SimulatedAudioHAL(nullptr);
    audioHal->moveToThread(audioThread);
    QObject::connect(audioThread, &QThread::finished, audioHal, &QObject::deleteLater);
    audioThread->start();

    // -------------------------------------------------------------------------
    // Application Services (Dependency Injection)
    // -------------------------------------------------------------------------
    
    // System Settings (Controls Audio, Persistence)
    // Passes audioHal pointer. Thread-safe due to QMutex in HAL.
    SystemSettings *settings = new SystemSettings(audioHal, &app);
    
    // Business Logic Services
    // VehicleService depends on VehicleHAL
    VehicleService *vehicleService = new VehicleService(vehicleHal, &app);
    MediaService *media = new MediaService(&app);
    NavigationService *nav = new NavigationService(&app);
    PhoneService *phone = new PhoneService(&app);
    // Layout Service (Responsive Design)
    // Layout Service (Responsive Design)
    LayoutService *layoutService = new LayoutService(&app);
    // Translation Service
    TranslationService *translationService = new TranslationService(&engine, &app);
    
    // 2. Register as Singletons
    qmlRegisterSingletonInstance("NordicHeadunit", 1, 0, "SystemSettings", settings);
    qmlRegisterSingletonInstance("NordicHeadunit", 1, 0, "VehicleService", vehicleService);
    qmlRegisterSingletonInstance("NordicHeadunit", 1, 0, "MediaService", media);
    qmlRegisterSingletonInstance("NordicHeadunit", 1, 0, "NavigationService", nav);
    qmlRegisterSingletonInstance("NordicHeadunit", 1, 0, "PhoneService", phone);
    qmlRegisterSingletonInstance("NordicHeadunit", 1, 0, "PhoneService", phone);
    qmlRegisterSingletonInstance("NordicHeadunit", 1, 0, "LayoutService", layoutService);
    qmlRegisterSingletonInstance("NordicHeadunit", 1, 0, "TranslationService", translationService);

    using namespace Qt::StringLiterals;
    
    // Manually register NordicTheme as a Singleton
    qmlRegisterSingletonType(QUrl(u"qrc:/qt/qml/NordicHeadunit/qml/NordicTheme.qml"_s), "NordicHeadunit", 1, 0, "NordicTheme");

    const QUrl url(u"qrc:/qt/qml/NordicHeadunit/qml/Main.qml"_s);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);
    
    // Connect to window resize events for Responsive Layouts
    if (!engine.rootObjects().isEmpty()) {
        QObject *rootObject = engine.rootObjects().first();
        QQuickWindow *window = qobject_cast<QQuickWindow *>(rootObject);
        if (window) {
            // Initial update
            layoutService->updateLayout(window->size());
            
            // Connect to resize (using generic QObject connect for property change if needed, but width/height signals work)
            QObject::connect(window, &QQuickWindow::widthChanged, [window, layoutService]() {
                layoutService->updateLayout(window->size());
            });
            QObject::connect(window, &QQuickWindow::heightChanged, [window, layoutService]() {
                layoutService->updateLayout(window->size());
            });
        }
    }

    return app.exec();
}
