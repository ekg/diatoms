#!/usr/bin/env python3

import datashader as ds
import datashader.transfer_functions as tf
from datashader.utils import export_imageq
#import pandas as pd
import dask_igzip
import sys

infile = sys.argv[1]
outfile = sys.argv[2]
dimension = int(sys.argv[3])
#scaling = int(sys.argv[3]) # number of positions per pixel
df = pd.read_csv(infile, sep="\t")
#mins = df.min()
#maxs = df.max()
#width = abs(maxs['POS_A'] - mins['POS_A'])
#height = abs(maxs['POS_B'] - mins['POS_B'])
#dimension = int(round(max(height, width) / float(scaling)))
cvs = ds.Canvas(plot_width=dimension, plot_height=dimension)
agg = cvs.points(df, 'POS_A', 'POS_B', ds.mean('R2'))
img = ds.transfer_functions.set_background(tf.shade(agg, cmap=['white', 'blue', 'red']), color="white")
export_image(img, outfile)
