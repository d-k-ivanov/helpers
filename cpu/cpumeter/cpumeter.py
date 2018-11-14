#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import unicode_literals


import sys
import psutil
try:
    # from Tkinter import *
    import Tkinter as tk
except ImportError:
    # from tkinter import *
    import tkinter as tk


class CpuMeter:
    def __init__(self, master, width, height):
        self.master = master
        self.ctl = True
        self.geo = (width, height)
        self.master.title("CPU Meter")
        self.setGeometry(self.geo)
        self.master.wm_resizable(False, False)
        # self.master.bind("<Configure>", self.onResize)

        self._job = None

        self.interval = 0.0
        self.buf = width
        self.buttons_frame = self.createControls()
        self.graph_frame = self.createGraph(self.master, self.geo)

    def onResize(self, event):
        """Reset geomery on resize window
        """
        self.setGeometry(self.geo)

    def setGeometry(self, geo):
        """ Sets geometry WxH
        """
        self.master.geometry('{}x{}'.format(geo[0] + 50, geo[1] + 150))

    def createControls(self):
        """Creates buttons

        :master: master
        :returns: buttons_frame

        """
        bf = tk.Frame(self.master, borderwidth=1, relief="raised")
        tk.Button(bf, text="Start", command=self.Start).grid(column=1, row=1)
        tk.Button(bf, text="Pause", command=self.Pause).grid(column=2, row=1)
        tk.Button(bf, text="Quit", command=self.Quit).grid(column=3, row=1)
        bf.pack(padx=20, pady=20, side="bottom")
        return bf

    def Start(self):
        b = self.update_buf(interval=self.interval, bufsize=self.buf)
        for i in range(len(b)):
            self.graph_frame.create_line(
                i, self.geo[1], i,
                self.geo[1] - (self.geo[1] / 100 * b[i]),
                fill='#333333'
            )
        self._job = self.master.after(100, self.Start)

    def Pause(self):
        if self._job is not None:
            self.master.after_cancel(self._job)
            self._job = None

    def Quit(self):
        self.master.destroy()

    def createGraph(self, master, geo):
        """Creates graph

        :master: master
        :returns: graph_frame

        """
        self.w = geo[0]
        self.h = geo[1]
        gf = tk.Canvas(master, bg="#d3dae3", bd=0, highlightthickness=0,
                       width=self.w, height=self.h)
        gf.pack(expand=1, padx=10, pady=10, side="top")
        return gf

    def update_buf(self, interval, bufsize=1, buf=[]):
        """Update buffer with cpu persent usage

        :interval: frequency
        :bufsize:  number of values
        :buf:      array of values size of bufsize
        :returns:  array of values

        """
        if len(buf) >= bufsize:
            buf.pop(0)
            buf.append(self.cpu_check(interval))
        else:
            buf.append(self.cpu_check(interval))
        return buf

    def cpu_check(self, interval):
        """Returns last percent of cpu usage within interval.

        :interval: frequency
        :returns:  percent of cpu usage

        """
        return psutil.cpu_percent(interval=interval)


if __name__ == "__main__":
    def main():
        width = 1000
        height = 500
        master = tk.Tk()
        CpuMeter(master, width, height)
        master.mainloop()

    sys.exit(main())
