#!/bin/python3
from rich import print
from rich.panel import Panel
from rich.layout import Layout

"""https://rich.readthedocs.io/en/latest/panel.html"""

layout = Layout()

layout.split_column(
    Layout(name="upper"),
    Layout(name="lower")
)

layout["lower"].split_row(
    Layout(name="left"),
    Layout(name="right"),
)

layout["right"].split(
    Layout(Panel("Hello")),
    Layout(Panel("World!"))
)

layout["left"].update(
    "The mystery of life isn't a problem to solve, but a reality to experience."
)

print(layout)