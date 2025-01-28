#-------------------------------------------------
#
# Project created by QtCreator 2012-05-13T21:55:33
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = TrackerKLT
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += main.cpp

INCLUDEPATH += C:\\opencv2.3_mingw\\install\\include

LIBS += -LC:\\opencv2.3_mingw\\install\\lib \
-lopencv_core231 \
-lopencv_highgui231 \
-lopencv_imgproc231 \
-lopencv_features2d231 \
-lopencv_calib3d231 \
-lopencv_video231
