// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:secret_hitler/backend/authentication/appwrite/auth_api.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';

class DatabaseApi {

  late final Databases _database;
  final String databaseId = appwriteDatabaseId;

  // Constructor
  DatabaseApi(AuthApi authApi) {
    _database = Databases(authApi.getClient());
  }

  // Method to create a document in a collection
  Future<bool> createDocument(String collectionId, String? documentId,
      Map<String, dynamic> data) async {
    try {
      await _database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId ?? 'unique()',
        data: data,
      );
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  // Method to get a document by the id from a specific collection
  Future<Document?> getDocumentById(String collectionId, String documentId) async {
    try {
      return await _database.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
    } catch(e) {
      print(e);
      return null;
    }
  }

  // Method to get a document by the attribute from a specific collection
  Future<Document?> getDocumentByAttribute(String collectionId,
      {List<String>? queries}) async {
    try {
      DocumentList? documents = await listDocuments(
        collectionId,
        queries: queries,
      );
      // If we get more than one document, the first one will be returned
      if (documents!.total > 0) {
        return documents.documents.first;
      } else {
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    }
  }

  // Method to list all documents from a collection
  Future<DocumentList?> listDocuments(String collectionId,
      {List<String>? queries}) async {
    try {
      return await _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: queries ?? [],
      );
    } catch(e) {
      print(e);
      return null;
    }
  }

  // Method to update a document with the given data
  Future<bool> updateDocument(String collectionId, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  // Method to delete a document
  Future<bool> deleteDocument(String collectionId, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _database.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }
}