import tensorflow as tf
import numpy as np
from flask import Flask, request, jsonify
from PIL import Image

app = Flask(__name__)

class_labels = ['Daisy', 'Dandelion', 'Hibiscus', 'Rose', 'Sunflower', 'Tulip']
# model_bucket = 'plant_classification_model'
model_path = 'tflite_model_sgd.tflite'

interpreter = tf.lite.Interpreter(model_path=model_path)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()


def preprocess_image(image):
    image = image.resize((224, 224))
    image_array = np.array(image) / 255.0
    image_array = np.expand_dims(image_array, axis=0)
    return image_array.astype('float32')


@app.route('/predict', methods=['POST'])
def predict():
    print(request.files)
    if 'image' not in request.files:
        return jsonify({'error': 'No image file found'})

    image_file = request.files['image']
    image = Image.open(image_file)
    image_array = preprocess_image(image)

    interpreter.set_tensor(input_details[0]['index'], image_array)
    interpreter.invoke()
    output = interpreter.get_tensor(output_details[0]['index'])

    predicted_class = np.argmax(output)
    predicted_probability = np.max(output)
    predicted_label = class_labels[predicted_class]

    predicted_class = int(predicted_class)

    response = {
        'predicted_class': predicted_class,
        'predicted_label': predicted_label,
        'predicted_probability': float(predicted_probability)
    }

    return jsonify(response)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
