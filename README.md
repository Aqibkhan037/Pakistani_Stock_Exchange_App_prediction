📈 PSX Stock Trading & Prediction App

A Flutter mobile application integrated with Flask AI backend and Express.js scraping service that allows users to trade Pakistan Stock Exchange (PSX) stocks while also providing AI-powered price predictions for the KSE-100 Index (daily timeframe).

This project combines mobile development, web scraping, and machine learning into a seamless trading and forecasting platform.
__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

🚀 Features

📱 Flutter Frontend (Mobile App)

User-friendly interface to view PSX stock data.

Simple trading simulation environment.

Displays predicted stock trends using AI models.

__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

🤖 Flask AI Backend

Built machine learning models with LSTMs and Transformers.

Predicts KSE-100 daily prices with time-series forecasting.

REST APIs to serve predictions directly to the app.

__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

🌐 Express.js Scraper Service

Uses Puppeteer to scrape daily and live PSX prices.

Cleans and formats the data for both trading and AI model input.

Updates backend databases with the most recent PSX market data.

🛠️ Tech Stack

Frontend (Mobile App): Flutter (Dart)

Backend (AI): Flask (Python)

Web Scraping Service: Express.js + Puppeteer

Machine Learning Models: LSTM, Transformer (PyTorch / TensorFlow)

Database: (MongoDB / PostgreSQL / SQLite – depending on setup)
__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

📊 AI/ML Models

LSTM (Long Short-Term Memory):
Used for capturing sequential patterns in stock price movements.

Transformers:
Applied for time-series forecasting to capture long-term dependencies and trend analysis.

Both models were trained on KSE-100 historical stock prices and deployed via Flask APIs.

__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

⚙️ Installation
1. Clone the Repository
git clone https://github.com/your-username/psx-trading-app.git
cd psx-trading-app

2. Setup AI Backend (Flask)
cd flask-backend
pip install -r requirements.txt
python app.py

3. Setup Scraper Service (Express.js)
cd express-scraper
npm install
node index.js

4. Run Flutter App
cd flutter-app
flutter pub get
flutter run

__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

🔮 Future Improvements

Add real trading APIs (integration with brokers).

Enhance prediction accuracy with hybrid ML models.

Build portfolio management and alerts system.

Add user authentication and secure database handling.

👨‍💻 Author

Muhammad Aqib

🚀 Full-Stack Developer (React, Django, Flutter, Python)

🤖 AI/ML Enthusiast | Time-Series & NLP

📫 Reach me: aqibkhan1582000@gmail.com | www.linkedin.com/in/aqib-khan-62187a250 | https://github.com/Aqibkhan037
