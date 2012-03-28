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
 * Charles Lindsay <chaz@yorba.org>
 */

import QtQuick 1.1

AlbumPageLayout {
  id: albumPageLayoutRightPortrait

  FramePortrait {
    id: right

    anchors.fill: parent

    topMargin: albumPageLayoutRightPortrait.topMargin
    bottomMargin: albumPageLayoutRightPortrait.bottomMargin
    leftMargin: albumPageLayoutRightPortrait.gutterMargin
    rightMargin: albumPageLayoutRightPortrait.outerMargin

    mediaSource: (albumPageLayoutRightPortrait.mediaSourceList
      ? albumPageLayoutRightPortrait.mediaSourceList[0]
      : null)
    isPreview: albumPageLayoutRightPortrait.isPreview
  }
}
