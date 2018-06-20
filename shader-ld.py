#!/usr/bin/env python3

import datashader as ds
import datashader.transfer_functions as tf
from datashader.utils import export_image
import pandas as pd
import sys

infile = sys.argv[1]
outfile = sys.argv[2]
dimension = int(sys.argv[3])
df = pd.read_csv(infile, sep="\t", compression='gzip')
cvs = ds.Canvas(plot_width=dimension, plot_height=dimension)
agg = cvs.points(df, 'POS_A', 'POS_B', ds.mean('R2'))
img = ds.transfer_functions.set_background(tf.shade(agg, cmap=['white', 'blue', 'red']), color="white")
export_image(img, outfile)
