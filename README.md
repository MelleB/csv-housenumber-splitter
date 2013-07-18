
CSV House Number Splitter
=========================
Split a house number and its extension in a CSV file into two separate fields.

Limitations:
 * Field separator is fixed to `;`
 * The field containing the house number is split into a `HouseNumber` and a
   `HouseNumberExtension` column

Usage
-----

    Usage: csv-housenumber-splitter [column index] [filename]
           Column count starts at 1.

Example input `dummy-hn.csv`:

    CustomerId;HouseNumber;SomeOtherColumn
    customer1;10;bla
    customer2;11a;1bla
    customer3;11-a
    customer4;171\a
    customer5;171.bis
    customer6;123/1

Example output `dummy-hn-hnsplit.csv`:

    CustomerId;HouseNumber;HouseNumberExtension;SomeOtherColumn
    customer1;10;;bla
    customer2;11;a;1bla
    customer3;11;a
    customer4;171;a
    customer5;171;bis
    customer6;123;1


License
-------
BSD3, see LICENSE file for details

