# expenses_tracker

A flutter application to keep track of user's transactions throughout a week and display them graphically as well as in a list view.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

The application makes use of shared_preverences package provided by pub dev to get an instance of the user's local storage (documents). The data from the user's transaction is encoded as a JSON string, written in a text file and stored. The list is sorted by the order of the date of transaction before being written.

This application makes use of JSON serializable to serialize the Transaction model class for easier JSON encoding and decoding. 
