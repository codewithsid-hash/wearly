# app/utils.py
# import cv2
# import numpy as np
# from sklearn.cluster import KMeans

# def get_dominant_color(image, k=4):
#     img = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
#     img = img.reshape((-1, 3))
#     kmeans = KMeans(n_clusters=k)
#     kmeans.fit(img)
#     dominant = kmeans.cluster_centers_[0].astype(int)
#     return {'r': int(dominant[0]), 'g': int(dominant[1]), 'b': int(dominant[2])}
# app/utils.py

import cv2
import numpy as np
from collections import Counter

def get_dominant_color(image, k=4):
    # Resize image to speed up processing
    image = cv2.resize(image, (50, 50))
    image = image.reshape((-1, 3))
    image = np.float32(image)

    # KMeans clustering
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 1.0)
    _, labels, palette = cv2.kmeans(image, k, None, criteria, 10, cv2.KMEANS_RANDOM_CENTERS)

    _, counts = np.unique(labels, return_counts=True)
    dominant = palette[np.argmax(counts)].astype(int)

    return f'rgb({dominant[0]}, {dominant[1]}, {dominant[2]})'
