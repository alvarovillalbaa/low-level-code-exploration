class Logger:
    def __init__(self):
        self.lines = []

    def log(self, msg: str):
        self.lines.append(msg)

