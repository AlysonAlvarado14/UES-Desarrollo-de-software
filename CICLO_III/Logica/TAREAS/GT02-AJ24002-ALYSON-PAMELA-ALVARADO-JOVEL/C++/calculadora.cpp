// Programa en C++ para ilustrar el paso
// de funciones como parámetros de objeto
#include <functional>
#include <iostream>
using namespace std;

// Definir las funciones add(suma), subtract(resta), multiply(producto) y divide(división)
// para devolver sus respectivos valores con números reales (double)
double suma(double x, double y)
{
    return x + y;
}

double resta(double x, double y)
{
    return x - y;
}

double multiplicacion(double x, double y)
{
    return x * y;
}

double division(double x, double y)
{
    if (y == 0) {
        cout << "Error: ¡División por cero!" << endl;
        return 0;
    }
    return x / y;
}

// Función que acepta un objeto de
// tipo std::function<> como parámetro
double invoke(double x, double y, function<double(double, double)> func)
{
    return func(x, y);
}

// Código principal
int main()
{
    double x, y;
    char operacion;

    cout << "Seleccione la operación aritmética (+, -, *, /): ";
    cin >> operacion;

    cout << "Ingrese la primera cantidad: ";
    cin >> x;
    cout << "Ingrese la segunda cantidad: ";
    cin >> y;

    switch (operacion) {
        case '+':
            cout << "Suma de " << x << " y " << y << " es ";
            cout << invoke(x, y, &suma) << '\n';
            break;
        case '-':
            cout << "Resta de " << x << " y " << y << " es ";
            cout << invoke(x, y, &resta) << '\n';
            break;
        case '*':
            cout << "Multiplicación de " << x << " y " << y << " es ";
            cout << invoke(x, y, &multiplicacion) << '\n';
            break;
        case '/':
            cout << "División de " << x << " y " << y << " es ";
            cout << invoke(x, y, &division) << '\n';
            break;
        default:
            cout << "Operación no válida." << endl;
            break;
    }

    return 0;
}