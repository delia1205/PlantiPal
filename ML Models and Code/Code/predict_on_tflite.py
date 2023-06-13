import tensorflow as tf
import numpy as np

# load only the .tflite model
interpreter = tf.lite.Interpreter(model_path='tflite_model_sgd_15.tflite')
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

class_labels = ['Daisy', 'Dandelion', 'Hibiscus', 'Rose', 'Sunflower', 'Tulip']

# list of images to be predicted on
img_paths = ['daisy.jpg', 'dandelion.jpg', 'tulip.jpg', 'hibiscus.jpg', 'sunflower.jpg', 'rose.jpg',
             'daisy2.jpg', 'tulip2.jpg', 'hibiscus2.jpg', 'hibiscus3.jpg']
predictions_list = []
pred_prob = []

for img_path in img_paths:
    img = tf.keras.preprocessing.image.load_img(img_path, target_size=(224, 224))
    img_array = tf.keras.preprocessing.image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0

    interpreter.set_tensor(input_details[0]['index'], img_array)

    interpreter.invoke()

    output = interpreter.get_tensor(output_details[0]['index'])
    predicted_class = np.argmax(output)
    predicted_probability = np.max(output)

    predicted_label = class_labels[predicted_class]
    predictions_list.append(predicted_label)
    pred_prob.append(predicted_probability)

for i, img_path in enumerate(img_paths):
    print("Image:", img_path)
    print("Predicted plant:", predictions_list[i])
    print("Probability: {:.2%}".format(pred_prob[i]))
    print()
