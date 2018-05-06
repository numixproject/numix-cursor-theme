# Changes from the original

* Change Inkscape to ImageMagick because I don't have it.
* Change output directorys because my grep doesn't support perl.
* Link top_left_arrow to left_ptr because gtk2 and X apps requires it.

The designs are never changed.

# numix-cursor-theme

A cursor theme based on icons from the [Numix icon theme](https://github.com/numixproject/numix-icon-theme/issues)

###Installing 

Download or clone the repository

If you have Numix already installed in `/usr/share/icons` and you are using either the dark or light variant copy everything inside the `Numix{-Light}` folder to `/usr/share/icons/Numix{-Light}`/.

If you have Numix installed locally, you can either copy the same folder to your Numix installation or if you want that your cursors show up everywhere, copy the whole `Numix{-Light}`folder to `/usr/share/icons`

Set the cursor theme using either `unity-tweak-tool` or a terminal :

    gsettings set org.gnome.desktop.interface cursor-theme 'Numix{-Light}'

For system-wide change run the following:

    sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/Numix{-Light}/cursor.theme 55
    sudo update-alternatives --set x-cursor-theme /usr/share/icons/Numix{-Light}/cursor.theme

Then restart or log out and back in for the changes to take effect.

### Building

You need inkscape and xcursorgen installed. 

Source icons are svg files stored in `src/{light/dark}/svgs`. 

`cd` into the repos folder and run `./build.sh`, the respective cursor icons are then generated and saved to both the `Numix{-Light}`folders
