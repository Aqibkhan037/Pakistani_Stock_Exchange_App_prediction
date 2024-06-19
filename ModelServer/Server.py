from flask import Flask, jsonify
from tensorflow.keras.models import load_model
import numpy as np

app = Flask(__name__)

model = load_model('my_model.keras')

@app.route('/predict', methods=['GET'])
def predict():
    # Define the input data
    max_value = 766.0
    min_value = 72742.0

    input_data = np.array([[0.86403801, 0.87738969, 0.8885184 , 0.90942814, 0.90649661,
        0.91224853, 0.89632655, 0.89868845, 0.90813605, 0.85359009,
        0.86232911, 0.8569801 , 0.86038402, 0.84665722, 0.81143715,
        0.83495888, 0.85147827, 0.85702179, 0.88772646, 0.88339169,
        0.88751806, 0.88742081, 0.88568412, 0.88183561, 0.88090475,
        0.87741747, 0.88711515, 0.88739302, 0.8822802 , 0.87488885,
        0.87252695, 0.86745582, 0.8685673 , 0.87769534, 0.88485051,
        0.88996332, 0.88268312, 0.87594476, 0.8614955 , 0.84854674,
        0.43365844, 0.85621596, 0.86467711, 0.87575025, 0.88052962,
        0.8638574 , 0.83776537, 0.84000222, 0.85288152, 0.83714016,
        0.8211904 , 0.82934589, 0.82941536, 0.84462877, 0.84956096,
        0.86207903, 0.86888685, 0.86769201, 0.87441647, 0.8865733 ,
        0.89695176, 0.90564911, 0.90252306, 0.90155052, 0.90081416,
        0.90345393, 0.90292598, 0.88967156, 0.87920974, 0.89332555,
        0.88987996, 0.89090808, 0.89941091, 0.90259253, 0.89822997,
        0.89453429, 0.89973047, 0.9050239 , 0.90003612, 0.92219629,
        0.92029288, 0.91738913, 0.91863955, 0.93072691, 0.93989663,
        0.95661054, 0.96626653, 0.96946204, 0.96861454, 0.96653051,
        0.96593309, 0.97453318, 0.98181338, 0.98078526, 0.99039958,
        0.9892881 , 1.        , 0.98545348, 0.97721463, 0.97103201]])

    # Reshape data to match model input shape
    input_data = input_data.reshape((1, 100,1))  # Assuming the shape is (1, 100, 1)

    # Use your LSTM model to make predictions
    prediction = model.predict(input_data)

    # Convert prediction to a scalar value (assuming your model outputs a single value)
    prediction_value = prediction[0][0]
    
    predicted = float(prediction_value)
    prediction_original_scale = (predicted * (max_value - min_value) + min_value)*10

    # Return prediction as JSON
    
    return jsonify({'prediction': prediction_original_scale})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)