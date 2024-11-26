// BD.swift
// Hack1
//
//  Created by CEDAM10 on 26/11/24.
//

import SQLite3
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {
        openDatabase()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("UserDatabase.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error al abrir la base de datos")
        } else {
            print("Base de datos abierta o creada correctamente en \(fileURL.path)")
        }

        createTables()
    }

    private func createTables() {
        let createUsersTableQuery = """
        CREATE TABLE IF NOT EXISTS Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT,
            last_name TEXT,
            email TEXT,
            phone TEXT
        );
        """

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, createUsersTableQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Tabla Users creada o ya existe")
            } else {
                print("No se pudo crear la tabla Users")
            }
        } else {
            print("Error al preparar la consulta CREATE TABLE para Users")
        }
        sqlite3_finalize(statement)

        let createUserDetailsTableQuery = """
        CREATE TABLE IF NOT EXISTS UserDetails (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            allergies TEXT,
            blood_type TEXT,
            chronic_diseases TEXT,
            emergency_contacts TEXT,
            FOREIGN KEY(user_id) REFERENCES Users(id)
        );
        """

        if sqlite3_prepare_v2(db, createUserDetailsTableQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Tabla UserDetails creada o ya existe")
            } else {
                print("No se pudo crear la tabla UserDetails")
            }
        } else {
            print("Error al preparar la consulta CREATE TABLE para UserDetails")
        }
        sqlite3_finalize(statement)
    }

    // Insertar usuario
    func insertUser(firstName: String, lastName: String, email: String, phone: String) {
        let insertQuery = "INSERT INTO Users (first_name, last_name, email, phone) VALUES (?, ?, ?, ?);"

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (lastName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (phone as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Usuario insertado correctamente")
            } else {
                print("Error al insertar usuario")
            }
        } else {
            print("Error al preparar la consulta INSERT para Users")
        }
        sqlite3_finalize(statement)
    }

    // Insertar detalles de usuario
    func insertUserDetails(userId: Int, allergies: String, bloodType: String, chronicDiseases: String, emergencyContacts: String) {
        let insertQuery = "INSERT INTO UserDetails (user_id, allergies, blood_type, chronic_diseases, emergency_contacts) VALUES (?, ?, ?, ?, ?);"

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))
            sqlite3_bind_text(statement, 2, (allergies as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (bloodType as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (chronicDiseases as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (emergencyContacts as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Detalles de usuario insertados correctamente")
            } else {
                print("Error al insertar detalles de usuario")
            }
        } else {
            print("Error al preparar la consulta INSERT para UserDetails")
        }
        sqlite3_finalize(statement)
    }

    // Obtener detalles de usuario
    func fetchUserDetails(userId: Int) -> (allergies: String, bloodType: String, chronicDiseases: String, emergencyContacts: String)? {
        let fetchQuery = "SELECT allergies, blood_type, chronic_diseases, emergency_contacts FROM UserDetails WHERE user_id = ?;"

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, fetchQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))

            if sqlite3_step(statement) == SQLITE_ROW {
                let allergies = String(cString: sqlite3_column_text(statement, 0))
                let bloodType = String(cString: sqlite3_column_text(statement, 1))
                let chronicDiseases = String(cString: sqlite3_column_text(statement, 2))
                let emergencyContacts = String(cString: sqlite3_column_text(statement, 3))

                sqlite3_finalize(statement)
                return (allergies, bloodType, chronicDiseases, emergencyContacts)
            }
        } else {
            print("Error al preparar la consulta SELECT para UserDetails")
        }
        sqlite3_finalize(statement)
        return nil
    }

    // Obtener todos los usuarios con detalles
    func fetchUsersWithDetails() -> [(id: Int, firstName: String, lastName: String, email: String, phone: String, allergies: String, bloodType: String, chronicDiseases: String, emergencyContacts: String)] {
        let fetchQuery = """
        SELECT u.id, u.first_name, u.last_name, u.email, u.phone, ud.allergies, ud.blood_type, ud.chronic_diseases, ud.emergency_contacts
        FROM Users u
        LEFT JOIN UserDetails ud ON u.id = ud.user_id;
        """
        
        var statement: OpaquePointer?
        var usersWithDetails: [(id: Int, firstName: String, lastName: String, email: String, phone: String, allergies: String, bloodType: String, chronicDiseases: String, emergencyContacts: String)] = []

        if sqlite3_prepare_v2(db, fetchQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let firstName = String(cString: sqlite3_column_text(statement, 1))
                let lastName = String(cString: sqlite3_column_text(statement, 2))
                let email = String(cString: sqlite3_column_text(statement, 3))
                let phone = String(cString: sqlite3_column_text(statement, 4))
                let allergies = String(cString: sqlite3_column_text(statement, 5))
                let bloodType = String(cString: sqlite3_column_text(statement, 6))
                let chronicDiseases = String(cString: sqlite3_column_text(statement, 7))
                let emergencyContacts = String(cString: sqlite3_column_text(statement, 8))

                usersWithDetails.append((id: Int(id), firstName: firstName, lastName: lastName, email: email, phone: phone, allergies: allergies, bloodType: bloodType, chronicDiseases: chronicDiseases, emergencyContacts: emergencyContacts))
            }
        } else {
            print("Error al preparar la consulta SELECT para obtener todos los usuarios con detalles")
        }
        sqlite3_finalize(statement)
        return usersWithDetails
    }

    // Cerrar la base de datos
    deinit {
        sqlite3_close(db)
    }
}
