#!./venv_python3/bin/python

import lmdb
import argparse


class ConfirmationHeightTable:

    def __init__(self, filename):
        self.filename = filename

    def print_confirmation_height(self):
        with lmdb.open(self.filename,
                       subdir=False,
                       max_dbs=10000,
                       map_size=1000 * 1000 * 1000 * 1000) as env:
            confirmation_height_db = env.open_db(b'confirmation_height')
            with env.begin() as tx:
                for key, value in tx.cursor(db=confirmation_height_db):
                    print(key, value)

    def delete_confirmation_height(self):
        with lmdb.open(self.filename,
                       subdir=False,
                       max_dbs=10000,
                       map_size=1000 * 1000 * 1000 * 1000) as env:
            confirmation_height_db = env.open_db(b'confirmation_height')
            with env.begin(write=True) as tx:
                for conf_height, _ in tx.cursor(db=confirmation_height_db):
                    # print('Deleting conf_height %s' %ConfirmationHeightTable.parse_entry(conf_height))
                    tx.delete(conf_height, db=confirmation_height_db)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d',
                        '--dataldb',
                        default='data.ldb',
                        help='data.ldb path')
    parser.add_argument('command', help='print, add, delete or delall')
    return parser.parse_args()


def main():
    args = parse_args()

    confirmation_height_table = ConfirmationHeightTable(args.dataldb)

    if args.command == 'print':
        confirmation_height_table.print_confirmation_height()
    elif args.command == 'delall':
        confirmation_height_table.delete_confirmation_height()
    else:
        print('Unknown command %s', args.command)


if __name__ == "__main__":
    main()
