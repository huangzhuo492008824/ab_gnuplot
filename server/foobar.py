from flask import Flask, jsonify
from gevent import monkey
monkey.patch_all()

app = Flask(__name__)

@app.route('/', methods=['GET'])
def hello():
    #return 'hello'
    return jsonify({'msg': "Hello World"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
