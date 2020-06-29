from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Welcome to a very simple flask server!"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

