#!/bin/python3

from datetime import datetime
from rich import print
from rich import pretty
from rich.color import Color
from rich.panel import Panel
from rich.layout import Layout
from rich.console import Console

layout = Layout()
console = Console()

layout.split_column(
    Layout(name = "header"),
#     Layout(name = "system"),
#     Layout(name = "connection"),
#     Layout(name = "storage"),
#     Layout(name = "footer")
)

layout["header"].split(
    Layout(Panel(
        console.print([1, 2, 3]),
        console.print("[blue underline]Looks like a link"),
        console.print("FOO", style="white on blue")
    ))
)

print(layout)