# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2012 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.


"""Tests for the Gallery App"""

from __future__ import absolute_import

from testtools.matchers import Equals, NotEquals
from autopilot.matchers import Eventually

from goodhope.tests import GoodhopeTestCase


class TestAlbumEditor(GoodhopeTestCase):
    """Tests the main gallery features"""

    """ This is needed to wait for the application to start.
        In the testfarm, the application may take some time to show up."""
    def setUp(self):
        super(TestAlbumEditor, self).setUp()
        self.assertThat(self.album_editor.get_qml_view().visible, Eventually(Equals(True)))

        self.click_albums_tab()
        self.click_plus_icon()

    def tearDown(self):
        super(TestAlbumEditor, self).tearDown()

    def click_albums_tab(self):
        albums_tab = self.album_editor.get_albums_tab()

        self.mouse.move_to_object(albums_tab)
        self.mouse.click()

        self.assertThat(albums_tab.state, Eventually(Equals("selected")))

    def click_plus_icon(self):
        add_icon = self.album_editor.get_plus_icon()

        self.mouse.move_to_object(add_icon)
        self.mouse.click()

    def test_album_title_field_default_text(self):
        """Ensures the default text of the title field is intact."""
        album_editor = self.album_editor.get_album_editor()

        # self.click_albums_tab()
        # self.click_plus_icon()

        title_field = self.album_editor.get_album_title_entry_field()

        self.assertThat(title_field.text, Eventually(Equals("New Photo Album")))

    def test_album_subtitle_field_default_text(self):
        """Ensures the default text of the subtitle field is intact."""
        album_editor = self.album_editor.get_album_editor()

        # self.click_albums_tab()
        # self.click_plus_icon()

        subtitle_field = self.album_editor.get_album_subtitle_entry_field()

        self.assertThat(subtitle_field.text, Eventually(Equals("Subtitle")))
