from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
# change 'pgress' to 'localhost' if app doesn't run in docker
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://todo:password@3.122.70.222:5432/todo_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100))
    complete = db.Column(db.Boolean, default=False)

@app.route("/")
def home():
    try:
        todo_list = Todo.query.all()
    except Exception as e:
        return f"An error occurred: {str(e)}"
    return render_template("main.html", todo_list=todo_list)

@app.route("/add", methods=["POST"])
def add():
    try:
        title = request.form.get("title")
        new_todo = Todo(title=title)
        db.session.add(new_todo)
        db.session.commit()
    except Exception as e:
        return f"An error occurred: {str(e)}"
    return redirect(url_for("home"))

@app.route("/update/<int:todo_id>")
def update(todo_id):
    try:
        todo = Todo.query.get_or_404(todo_id)
        todo.complete = not todo.complete
        db.session.commit()
    except Exception as e:
        return f"An error occurred: {str(e)}"
    return redirect(url_for("home"))

@app.route("/delete/<int:todo_id>")
def delete(todo_id):
    try:
        todo = Todo.query.get_or_404(todo_id)
        db.session.delete(todo)
        db.session.commit()
    except Exception as e:
        return f"An error occurred: {str(e)}"
    return redirect(url_for("home"))

@app.route("/delete_completed", methods=["GET", "POST"])
def delete_completed():
    try:
        completed_todos = Todo.query.filter_by(complete=True).all()
        for todo in completed_todos:
            db.session.delete(todo)
        db.session.commit()
    except Exception as e:
        return f"An error occurred: {str(e)}"
    return redirect(url_for("home"))

@app.route("/delete_all", methods=["GET", "POST"])
def delete_all():
    try:
        all_todos = Todo.query.all()
        for todo in all_todos:
            db.session.delete(todo)
        db.session.commit()
    except Exception as e:
        return f"An error occurred: {str(e)}"
    return redirect(url_for("home"))

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")