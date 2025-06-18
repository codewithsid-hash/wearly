# app/utils.py
import cv2
import numpy as np
from sklearn.cluster import KMeans

def get_dominant_color(image, k=4):
    img = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    img = img.reshape((-1, 3))
    kmeans = KMeans(n_clusters=k)
    kmeans.fit(img)
    dominant = kmeans.cluster_centers_[0].astype(int)
    return {'r': int(dominant[0]), 'g': int(dominant[1]), 'b': int(dominant[2])}
