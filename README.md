# Numix Cursor Theme
A cursor theme based on icons from the [Numix icon theme](https://github.com/numixproject/numix-icon-theme). Code and assets licensed GPL v3+.


### Installing
Download and extract the [latest release](https://github.com/numixproject/numix-cursor-theme/releases/latest) from GitHub. Then copy the `Numix-Cursor` and `Numix-Cursor-Light` folders to `/usr/share/icons`. Set the cursor theme using either your system settings or a terminal as follows:

```bash
gsettings set org.gnome.desktop.interface cursor-theme 'Numix-Cursor{-Light}'
```

For system-wide change run the following:

```bash
sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/Numix-Cursor{-Light}/cursor.theme 55
sudo update-alternatives --set x-cursor-theme /usr/share/icons/Numix-Cursor{-Light}/cursor.theme
```

Restart or log out and back in for the changes to take effect.

### Building
To build the themes from source you'll need Inkscape and xcursorgen installed. Then run the following in a terminal:

```bash
git clone https://github.com/numixproject/numix-cursor-theme.git
cd numix-cursor-theme/
./build.sh
```

The respective cursor icons are then generated and saved to both the `Numix-Cursor{-Light}` folders.
