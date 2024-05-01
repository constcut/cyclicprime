import os
import telebot
import json

from subprocess import check_call
import threading
from Rational import Rational
from DigitalCircle import DigitalCircle, DigitalCircleList


class MathBot:
    def __init__(self, config_name):
        with open(config_name, "r") as file:
            self._config = json.load(file)
        self.bot = telebot.TeleBot(self._config["key"])

    def handle_command(self, message):
        command_steps = message.text.split()
        path_user_logs = self._config["dir"] + "/" + str(message.chat.id)
        if not os.path.exists(path_user_logs):
            os.makedirs(path_user_logs)
        print("cs", command_steps)
        if command_steps[0] == "!help":
            self.bot.send_message(
                message.chat.id,
                "Try !rational num denom numeric_system (for example !r 1 7 10)",
                reply_to_message_id=message.id,
            )
        elif command_steps[0] == "!rational" or command_steps[0] == "!r":
            r = Rational()
            r.calc(int(command_steps[1]), int(command_steps[2]), int(command_steps[3]))
            r.isCyclic()  # TODO speed up so we can run 127+
            resp = f"{r.getFullString()}\nRemains {r.remains()}\nMultiply shift {r.multiplyShift()}."
            resp += f"\nScales period: {r.scalesPeriod()}\nRegularity: {r.regularity()}\nDigits: {r.digitSpectrum()}"
            self.bot.send_message(message.chat.id, resp, reply_to_message_id=message.id)
        elif command_steps[0] == "!circle" or command_steps[0] == "!c":
            circle = DigitalCircle()
            # TODO

    def send_delayed_text(self, message):
        if message.text[0] == "!":
            self.handle_command(message)
            print("command finished for", message.chat.id)
            return

    def set_handlers(self):
        @self.bot.message_handler(commands=["start", "help"])
        def send_welcome(message):
            self.bot.reply_to(message, "Ask !help for help")

        @self.bot.message_handler(func=lambda message: True)
        def echo_all(message):
            t = threading.Timer(1.0, self.send_delayed_text, [message])
            t.start()

    def start_bot(self):
        self.set_handlers()
        print("Starting bot")
        self.bot.infinity_polling()
        print("Bot is finished")


print("Waiting for wifi")
# time.sleep(10) # Для Raspbery Pi установить связь с Wifi
r = MathBot("key.json")
r.start_bot()
