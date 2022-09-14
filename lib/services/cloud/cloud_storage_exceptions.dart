class CloudStorageExeption implements Exception {
  const CloudStorageExeption();
}

// C
class CouldNotCreateNoteException extends CloudStorageExeption {}

// R
class CouldNotGetAllNotesException extends CloudStorageExeption {}

//U
class CouldNotUpdateAllNotesException extends CloudStorageExeption {}

//D
class CouldNotDeleteAllNotesException extends CloudStorageExeption {}

