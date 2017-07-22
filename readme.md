# Website prank

This prank generator creates a Bash script which you can use to trick your
friend or colleague.

The generated prank script adds a given domain to the `/etc/hosts` file,
starts a small service listening on port 80 and serving a prank webpage.
The webpage shows a full screen image that you set using the generator.

## Disclaimer

I made this script to trick one of my colleagues who sent a funny email using
my name and email address. We laughed together on the prank, nobody got hurt.

The script should run alright on Ubuntu 16.04 with a basic setup, no special
Bash aliases set. However in a customized environment it can have unexpected
effects, so please examine the script templates first and check if they are OK
for your system.

__Use it at your own risk, I take absolutely no responsibility.__

## Usage

### Generating a prank script:

```
./prank_generator.sh -h 'prank.loc' -t 'Prank!' -m 'image/jpeg' -i prank.jpg > prank.sh
chmod +x prank.sh
```

Parameters:
- `-h` or `--hostname`:
  The domain that will be written to the `/etc/hosts` file.
- `-t` or `--pagetitle`:
  The title of the served web page.
- `-m` or `--imagemime`:
  The mime type of the image, e.g.: "image/jpeg".
- `-i` or `--imagpath`:
  The path to the image that will be shown on the served webpage.

### Starting the prank

```
sudo ./prank.sh
```

You can now use a link with the given domain, e.g.
http://prank.loc/h8d7ash9, it will show the given image.

### Stopping the prank

Well, it's a little more difficult.

Run:
```
sudo lsof -i tcp:80
```

Find the PID (process ID) of the Python script serving the prank webpage.

Kill the server Python script:
```
sudo kill {the PID of the Python script}
```

### Restoring /etc/hosts if something goes wrong

The script creates a backup of the `/etc/hosts` file on the first run, you can
find it under: `/etc/hosts.backup_before_prank_{UUID}`
