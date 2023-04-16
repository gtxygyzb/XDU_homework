from tkinter import END
import cv2
import tkinter as tk
import numpy as np
from tkinter import *
from PIL import Image, ImageTk
import os
import tkinter.filedialog as tkf
import common
import GLCM


class frame:
    window = tk.Tk()
    selectbt = tk.Button()
    canvas = tk.Canvas()
    canvas1 = tk.Canvas()
    canvas2 = tk.Canvas()
    canvas3 = tk.Canvas()
    canvas4 = tk.Canvas()
    canvas5 = tk.Canvas()
    canvas6 = tk.Canvas()
    canvas7 = tk.Canvas()
    canvas8 = tk.Canvas()
    canvas9 = tk.Canvas()

    def __init__(self):
        self.window_set()
        self.button_set()
        self.canvas_set()
        self.window.mainloop()

    def window_set(self):
        self.window.title("图像纹理特征提取")
        self.window.geometry("800x500")
        width = 1000
        height = 700
        ws = self.window.winfo_screenwidth()
        hs = self.window.winfo_screenheight()
        x = (ws / 2) - (width / 2)
        y = (hs / 2) - (height / 2)
        self.window.geometry('%dx%d+%d+%d' % (width, height, x, y))
        self.window.resizable(False, False)
        self.window.configure(bg='#FAFAD2')
        self.window.rowconfigure(1, weight=1)
        self.window.columnconfigure(0, weight=1)

    def button_set(self):
        self.selectbt = tk.Button(self.window, text='导入图片', font=('中文简体', 15), fg='black', bg='#00FFEE', height=1,
                                  width=20, command=self.PictureSelect)
        self.selectbt.grid(padx=0, pady=0, row=4, column=0, columnspan=2)

    def canvas_set(self):
        self.canvas = Canvas(self.window, bg='#FAFAD2', width=512, height=512)
        self.canvas.grid(padx=5, pady=5, row=1, column=0, rowspan=3)
        self.canvas1 = Canvas(self.window, bg='#FAFAD2', width=128, height=128)
        self.canvas1.grid(padx=5, pady=5, row=1, column=1)
        self.canvas2 = Canvas(self.window, bg='#FAFAD2', width=128, height=128)
        self.canvas2.grid(padx=5, pady=5, row=1, column=2)
        self.canvas3 = Canvas(self.window, bg='#FAFAD2', width=128, height=128)
        self.canvas3.grid(padx=5, pady=5, row=2, column=1)
        self.canvas4 = Canvas(self.window, bg='#FAFAD2', width=128, height=128)
        self.canvas4.grid(padx=5, pady=5, row=2, column=2)
        self.canvas5 = Canvas(self.window, bg='#FAFAD2', width=128, height=128)
        self.canvas5.grid(padx=5, pady=5, row=3, column=1)
        self.canvas6 = Canvas(self.window, bg='#FAFAD2', width=128, height=128)
        self.canvas6.grid(padx=5, pady=5, row=3, column=2)
        self.canvas7 = Canvas(self.window, bg='#FAFAD2', width=128, height=128)
        self.canvas7.grid(padx=5, pady=5, row=4, column=1)
        self.canvas8 = Canvas(self.window, bg='#FAFAD2', width=128, height=128)
        self.canvas8.grid(padx=5, pady=5, row=4, column=2)

    def PictureSelect(self):
        filepath = tkf.askopenfilename()
        common.img = cv2.imread(filepath)
        glcm = GLCM.GLCM()
        img = Image.open("d:/img.jpg")
        bm = ImageTk.PhotoImage(img)
        self.canvas.create_image(256, 256, anchor=CENTER, image=bm)
        self.GLCMshow()
        self.window.mainloop()

    def GLCMshow(self):
        img1 = Image.open("d:/img1.jpg")
        bm1 = ImageTk.PhotoImage(img1)
        self.canvas1.create_image(64, 64, anchor=CENTER, image=bm1)

        img2 = Image.open("d:/img2.jpg")
        bm2 = ImageTk.PhotoImage(img2)
        self.canvas2.create_image(64, 64, anchor=CENTER, image=bm2)

        img3 = Image.open("d:/img3.jpg")
        bm3 = ImageTk.PhotoImage(img3)
        self.canvas3.create_image(64, 64, anchor=CENTER, image=bm3)

        img4 = Image.open("d:/img4.jpg")
        bm4 = ImageTk.PhotoImage(img4)
        self.canvas4.create_image(64, 64, anchor=CENTER, image=bm4)

        img5 = Image.open("d:/img5.jpg")
        bm5 = ImageTk.PhotoImage(img5)
        self.canvas5.create_image(64, 64, anchor=CENTER, image=bm5)

        img6 = Image.open("d:/img6.jpg")
        bm6 = ImageTk.PhotoImage(img6)
        self.canvas6.create_image(64, 64, anchor=CENTER, image=bm6)

        img7 = Image.open("d:/img7.jpg")
        bm7 = ImageTk.PhotoImage(img7)
        self.canvas7.create_image(64, 64, anchor=CENTER, image=bm7)

        img8 = Image.open("d:/img8.jpg")
        bm8 = ImageTk.PhotoImage(img8)
        self.canvas8.create_image(64, 64, anchor=CENTER, image=bm8)

        self.window.mainloop()


if __name__ == '__main__':
    myframe = frame()
