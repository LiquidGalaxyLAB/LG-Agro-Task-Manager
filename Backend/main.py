from queue import Queue
import time
import threading
from fastapi import FastAPI
from pydantic import BaseModel
from threading import Event

class Task:
    def __init__(self):
        self.task_name = ""
        self.completion_percent = 0.0

class Robot:
    def __init__(self):
        self.robot_id = 0

app = FastAPI()
queue = Queue()
current_task = Task()
exit_event = Event()

def manage_action(current_task):
    while current_task.completion_percent != 100.0:
        current_task.completion_percent += 1.0
        time.sleep(1)

def waiting_for_queue(current_task):
    while not exit_event.is_set():    
        try:
            if not queue.empty() and current_task.task_name == "":
                current_task.task_name = queue.get()
                manage_action(current_task)
                current_task.task_name = ""
                current_task.completion_percent = 0.0
        except Exception as e:
            print(f"Error at waiting_for_queue: {e}")

@app.on_event("shutdown")
def shutdown_event():
    exit_event.set()

@app.get("/get_current_task")
def get_current_task():
    data_to_send = {
        'task_name': current_task.task_name,
        'completion_percent': current_task.completion_percent
    }
    return data_to_send

class Data(BaseModel):
    item : str

@app.post("/add_item")
def add_item(data: Data):
    if data.item:
        queue.put(data.item)
        return f'Item added to the queue: {data.item}'
    else:
        return "Item is empty"

@app.get("/get_queue")
def get_queue():
    return list(queue.queue)

wait_thread = threading.Thread(target=waiting_for_queue, args=(current_task,))
wait_thread.start()
    
