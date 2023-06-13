import tensorflow as tf
from keras.preprocessing import image
from keras.models import load_model
import numpy as np

# load any of the models adam/sgd, 10/15/20
model = load_model('plant_classification_model_sgd_opt_15.h5')

# list of images to be predicted on
img_paths = ['daisy.jpg', 'dandelion.jpg', 'tulip.jpg', 'hibiscus.jpg', 'sunflower.jpg', 'rose.jpg',
             'daisy2.jpg', 'tulip2.jpg', 'hibiscus2.jpg', 'hibiscus3.jpg']
predictions_list = []
pred_prob = []

for img_path in img_paths:
    img = image.load_img(img_path, target_size=(224, 224))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0

    predictions = model.predict(img_array)
    predicted_class = np.argmax(predictions)
    predicted_probability = np.max(predictions)

    class_labels = ['Daisy', 'Dandelion', 'Hibiscus', 'Rose', 'Sunflower', 'Tulip']
    predicted_label = class_labels[predicted_class]
    predictions_list.append(predicted_label)
    pred_prob.append(predicted_probability)

for i, img_path in enumerate(img_paths):
    print("Image:", img_path)
    print("Predicted plant:", predictions_list[i])
    print("Probability: {:.2%}".format(pred_prob[i]))
    print()
