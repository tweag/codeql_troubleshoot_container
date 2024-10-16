import os
from flask import Flask, request

app = Flask(__name__)

@app.route('/ping', methods=['GET'])
def ping():
    # Get the IP address from the query parameter
    ip = request.args.get('ip')

    # Vulnerable command: unsanitized user input is passed to os.system()
    # This can lead to command injection if the user passes something like '127.0.0.1; rm -rf /'
    command = f"ping -c 1 {ip}"
    
    # Execute the command
    os.system(command)

    return f"Pinged {ip}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
