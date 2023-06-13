from keras.preprocessing.image import ImageDataGenerator
from keras.models import load_model

# load any of the models adam/sgd, 10/15/20
model = load_model('plant_classification_model_sgd_opt_15.h5')

image_size = (224, 224)
batch_size = 32

test_datagen = ImageDataGenerator(rescale=1.0/255.0)
test_generator = test_datagen.flow_from_directory(
    'validation/',
    target_size=image_size,
    batch_size=batch_size,
    class_mode='categorical'
)

loss, accuracy = model.evaluate(test_generator)
print("Accuracy:", accuracy)
print("Loss:", loss)
