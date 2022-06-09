#!/usr/bin/env python3

from pathlib import Path
import http.server
import ssl
import argparse


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-n", "--hostname", type=str, default="testhost")
    parser.add_argument("-c", "--certfile", type=Path, required=True)
    parser.add_argument("-k", "--certkey", type=Path, required=True)

    args = parser.parse_args()
    certfile: Path = args.certfile
    certkey: Path = args.certkey
    hostname: str = args.hostname

    server_address = (hostname, 443)
    httpd = http.server.HTTPServer(server_address, http.server.SimpleHTTPRequestHandler)
    httpd.socket = ssl.wrap_socket(
        httpd.socket,
        server_side=True,
        certfile=certfile,
        keyfile=certkey,
        ssl_version=ssl.PROTOCOL_TLS,
    )
    httpd.serve_forever()

if __name__ == "__main__":
    main()
