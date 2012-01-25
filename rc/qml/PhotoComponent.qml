/*
 * Copyright (C) 2011 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 * Jim Nelson <jim@yorba.org>
 * Lucas Beeler <lucas@yorba.org>
 */

import QtQuick 1.1

Rectangle {
  property variant mediaSource
  property bool isCropped: false
  property bool isPreview: false
  property bool isZoomable: false
  property int zoomFocusX: 0
  property int zoomFocusY: 0

  // treat these properties as constants
  property real kMaxZoomFactor: 2.5;
  
  signal loaded()
  
  clip: true

  function zoom(x, y) {
    // if this PhotoComponent isn't zoomable, make sure we're in the unzoomed
    // state then do a short-circuit return
    if (!isZoomable) {
      state = "unzoomed";
      return;
    }

    if (state == "unzoomed") {
      setZoomFocus(constrainToPanRegion(getZoomFocusFromMouse(x, y)));
      state = "zoomed";
    } else {
      state = "unzoomed";
      this.clearZoomFocus();
    }
  }

  function pan(x, y) {
    if (state != "zoomed")
      return;

    setImageTranslation(constrainToPanRegion(makePoint(x, y)));
  }

  function makePoint(x, y) {
    return { "x": x, "y": y };
  }

  function setImageTranslation(p) {
    image.x = p.x;
    image.y = p.y;
  }

  function getImageTranslation() {
    return makePoint(image.x, image.y);
  }

  function getZoomFocus() {
    return makePoint(zoomFocusX, zoomFocusY);
  }

  function constrainToPanRegion(p) {
    var panRegion = { "xMax": (image.paintedWidth * kMaxZoomFactor - width) / 2,
                      "yMax": (image.paintedHeight * kMaxZoomFactor - height) / 2,
                      "xMin": (width - (image.paintedWidth * kMaxZoomFactor)) / 2,
                      "yMin": (height - (image.paintedHeight * kMaxZoomFactor)) / 2 };

    var pLocal = { "x": p.x, "y": p.y };

    if (pLocal.x < panRegion.xMin)
      pLocal.x = panRegion.xMin;
    if (pLocal.y < panRegion.yMin)
      pLocal.y = panRegion.yMin;
    if (pLocal.x > panRegion.xMax)
      pLocal.x = panRegion.xMax;
    if (pLocal.y > panRegion.yMax)
      pLocal.y = panRegion.yMax;

    return pLocal;
  }

  function getZoomFocusFromMouse(x, y) {
    return makePoint((image.width / 2 - x) * kMaxZoomFactor, (image.height / 2 - y) * kMaxZoomFactor);
  }

  function setZoomFocus(p) {
    zoomFocusX = p.x;
    zoomFocusY = p.y;
  }

  function clearZoomFocus() {
    zoomFocusX = 0;
    zoomFocusY = 0;
  }

  states: [
    State { name: "unzoomed";
      PropertyChanges { target: image; scale: 1.0; x: 0; y: 0 } },

    State { name: "zoomed";
      PropertyChanges { target: image; scale: kMaxZoomFactor; x: zoomFocusX; y: zoomFocusY; } }
  ]

  transitions: [
    Transition { from: "*"; to: "*";
      NumberAnimation { properties: "x, y, scale"; easing.type: Easing.InQuad;
                        duration: 350; } }
  ]

  state: "unzoomed";

  onIsZoomableChanged: {
    if (!isZoomable) {
      state = "unzoomed";
    }
  }

  Image {
    id: image
    objectName: "image"
    
    source: {
      if (!parent.mediaSource)
        return "";
      
      return isPreview ? mediaSource.previewPath : mediaSource.path
    }
    
    x: 0
    y: 0
    
    transform: Scale {
      origin.x: width / 2
      origin.y: height / 2
      xScale: (mediaSource && !isPreview && mediaSource.orientationMirrored) ?
        -1.0 : 1.0
    }
    rotation: (mediaSource && !isPreview) ? mediaSource.orientationRotation :
      0.0
    
    // If image is rotated by transform/rotation properties, also rotate its
    // dimensions so the loader scales it properly
    width: (!isPreview && mediaSource && mediaSource.isRotated) ?
      parent.height : parent.width
    height: (!isPreview && mediaSource && mediaSource.isRotated) ?
      parent.width : parent.height
    
    sourceSize.width: (width <= 1024) ? (width * 2) : width
    
    asynchronous: true
    cache: true
    smooth: true
    fillMode: isCropped ? Image.PreserveAspectCrop : Image.PreserveAspectFit
    
    onStatusChanged: {
      if(image.status == Image.Ready)
        loaded();
    }
  }
}
