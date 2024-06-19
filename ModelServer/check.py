from flask import Flask, jsonify
from tensorflow.keras.models import load_model
import numpy as np

app = Flask(__name__)

model = load_model('testing.keras')

@app.route('/predict', methods=['GET'])
def predict():
    # Define the input data
    input_data = np.array([[[1.        ],
        [0.99016297],
        [0.99050072],
        [0.96538039],
        [0.98488559],
        [0.97086887],
        [0.94026007],
        [0.87748037],
        [0.83483915],
        [0.85413324],
        [0.77336823],
        [0.77269273],
        [0.88014017],
        [0.84007431],
        [0.89673225],
        [0.85527316],
        [0.83884995],
        [0.74233725],
        [0.82327113],
        [0.78143207],
        [0.6665963 ],
        [0.7921557 ],
        [0.64118044],
        [0.68614371],
        [0.66001013],
        [0.65203074],
        [0.58642236],
        [0.56586169],
        [0.66089673],
        [0.65515494],
        [0.70970193],
        [0.66452757],
        [0.69437642],
        [0.69218104],
        [0.63569197],
        [0.65266402],
        [0.63780292],
        [0.7267162 ],
        [0.71388162],
        [0.74191506],
        [0.75002111],
        [0.77222832],
        [0.83049059],
        [0.8194292 ],
        [0.8289707 ],
        [0.8125475 ],
        [0.78776492],
        [0.75162543],
        [0.78426074],
        [0.77974331],
        [0.81326522],
        [0.8141096 ],
        [0.79473106],
        [0.83336148],
        [0.85898843],
        [0.83901883],
        [0.85628641],
        [0.87486279],
        [0.88782403],
        [0.90095415],
        [0.92793211],
        [0.948535  ],
        [0.93333615],
        [0.91746179],
        [0.92544119],
        [0.91771511],
        [0.9483239 ],
        [0.94064004],
        [0.96635143],
        [0.9563033 ],
        [0.96491598],
        [0.96250933],
        [0.96524423],
        [0.96782768],
        [0.9709034 ],
        [0.97451705],
        [0.97862512],
        [0.983145  ],
        [0.98797315],
        [0.99300396],
        [0.99814492],
        [1.00332272],
        [1.00848651],
        [1.01360774],
        [1.01867616],
        [1.02369475],
        [1.02867639],
        [1.03363669],
        [1.03859222],
        [1.04355812],
        [1.04854524],
        [1.05356085],
        [1.05860794],
        [1.06368613],
        [1.06879294],
        [1.07392395],
        [1.07907462],
        [1.08423924],
        [1.08941412],
        [1.09459448]]])

    # Reshape data to match model input shape
    input_data = input_data.reshape((1, 100,1))  # Assuming the shape is (1, 100, 1)

    # Use your LSTM model to make predictions
    prediction = model.predict(input_data)

    # Convert prediction to a scalar value (assuming your model outputs a single value)
    prediction_value = prediction[0][0]

    # Return prediction as JSON
    predicted = float(prediction_value)
    return jsonify({'prediction': predicted})

if __name__ == '__main__':
    app.run(debug=True)