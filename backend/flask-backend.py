from flask import Flask, request, jsonify, send_file
import os
# from functools import wraps
from dotenv import load_dotenv
from werkzeug.utils import secure_filename

app = Flask(__name__)
load_dotenv("/home/webflowserver/flutter_app/.env")

API_KEY = os.getenv("API_KEY")
if not API_KEY:
    raise ValueError("it's not set smh")

UPLOAD_FOLDER = "/home/webflowserver/flutter_app/images/"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
ALLOWED_FOLDERS = ["suiet", "suahs", "gallery", "ias",
                   "icis", "ied", "ihmt", "imc", "ins", "ip", "issh"]
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif"}
app.config['MAX_CONTENT_LENGTH'] = 2 * 1000 * 1000

# def require_api_key(func):
#     @wraps(func)
#     def wrapper(*args, **kwargs):
#         key = request.headers.get("X-API-KEY")
#         if key != API_KEY:
#             return jsonify({
#             "error": "Unauthorized"
#             }), 401  # Use standard key names
#         return func(*args, **kwargs)
#     return wrapper


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def allowed_folder(foldername):
    if foldername not in ALLOWED_FOLDERS:
        return False
    return True

# UPLOAD ROUTE


@app.route("/upload/<string:institute>", methods=["POST"])
def upload_file(institute):

    # Check if API key is valid
    if request.headers.get("X-API-KEY") != API_KEY:
        return jsonify({"error": "Unauthorized"}), 401

    if "file" not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "No selected file"}), 400

    if not allowed_folder(institute):
        return jsonify({"error": "Folder doesn't exist"}), 400

    institute = institute + "/"
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(
            app.config["UPLOAD_FOLDER"], institute, filename)
        file.save(filepath)
        return jsonify({
            "message": "File uploaded successfully",
            "filename": filename
        }), 201

    return jsonify({"error": "Invalid file type"}), 400


# FETCH ROUTE
@app.route("/fetch/<string:institute>/<string:filename>", methods=["GET"])
def fetch_file(institute, filename):
    if not allowed_folder(institute):
        return jsonify({"error": "Folder doesn't exist"}), 400

    full_file_path = os.path.join(
        app.config["UPLOAD_FOLDER"], institute, filename)
    if os.path.exists(full_file_path):
        # response=make_response(send_file(full_file_path))
        # response.headers['Cache-Control']='public,max-age=172800'  # max amount of time, that is basically 2 days.
        # return response
        return send_file(full_file_path)

    else:
        return jsonify({"error": "File not found"}), 404


# DELETE ROUTE
@app.route("/delete/<string:institute>/<string:filename>", methods=["DELETE"])
def delete_file(institute, filename):

    # Check if API key is valid
    if request.headers.get("X-API-KEY") != API_KEY:
        return jsonify({"error": "Unauthorized"}), 401

    # Check if the institute folder is allowed
    if not allowed_folder(institute):
        return jsonify({"error": "Folder doesn't exist"}), 400

    # Build the full file path
    filepath = os.path.join(app.config["UPLOAD_FOLDER"], institute, filename)

    # Check if the file exists and delete it
    if os.path.exists(filepath):
        os.remove(filepath)
        return jsonify({
            "message": "File deleted successfully",
            "filename": filename
        }), 200
    else:
        return jsonify({"error": "File not found"}), 404


# IRRELEVANT
@app.route('/')
def hello_world():
    return '<p>Error Code 39: Check your wifi router for any intruders. There might just be something lurking there.</p>'
