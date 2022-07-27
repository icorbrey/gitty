#!/bin/bash

echo -n "Installing gitty to ~/.bashrc... "
cp ./gitty.sh ~/.gitty.sh
echo "source ~/.gitty.sh" >> ~/.bashrc
source ~/.bashrc
echo "Done!"
