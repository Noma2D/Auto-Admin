from flask import Flask, request
import requests
import json

app = Flask(__name__)

TELEGRAM_API_TOKEN = '6244055820:AAG_5YYbuy6hSPRt3uKJdFkcED6ZvrejkPY'
TELEGRAM_CHAT_ID = '-1001908199366'

@app.route('/', methods=['POST'])
def send_notification():
    data = request.get_data(as_text=True)
    alert = json.loads(data)['alerts'][0]

    alertname = alert['labels']['alertname']
    severity = alert['labels']['severity']
    summary = alert['annotations']['summary']
    description = alert['annotations']['description']

    message = f"{severity} Alert - {alertname}\n\n{summary}\n\n{description}"

    telegram_url = f"https://api.telegram.org/bot{TELEGRAM_API_TOKEN}/sendMessage"
    params = {
        'chat_id': TELEGRAM_CHAT_ID,
        'text': message,
    }

    requests.post(telegram_url, params=params)
    return 'ok'

if __name__ == '__main__':
    app.run(port=5000)

