#include <iostream>
#include <string>
using namespace std;

// Declaración de la estructura Persona
struct Persona {
    string nombre;
    string apellido;
    int edad;
    string telefono;
};

int main() {
    // Declaración de un arreglo de estructuras para 5 personas
    Persona listaPersonas[5];

    // Ingreso de datos para cada persona
    for (int i = 0; i < 5; i++) {
        cout << "\nIngrese los datos de la persona " << i + 1 << ":\n";
        cout << "Nombre: ";
        cin >> listaPersonas[i].nombre;
        cout << "Apellido: ";
        cin >> listaPersonas[i].apellido;
        cout << "Edad: ";
        cin >> listaPersonas[i].edad;
        cout << "Teléfono: ";
        cin >> listaPersonas[i].telefono;
    }

    // Mostrar los datos de las personas ingresadas
    cout << "\nLista de personas ingresadas:\n";
    for (int i = 0; i < 5; i++) {
        cout << "\nPersona " << i + 1 << ":\n";
        cout << "Nombre: " << listaPersonas[i].nombre << endl;
        cout << "Apellido: " << listaPersonas[i].apellido << endl;
        cout << "Edad: " << listaPersonas[i].edad << endl;
        cout << "Teléfono: " << listaPersonas[i].telefono << endl;
    }

    return 0;
}
