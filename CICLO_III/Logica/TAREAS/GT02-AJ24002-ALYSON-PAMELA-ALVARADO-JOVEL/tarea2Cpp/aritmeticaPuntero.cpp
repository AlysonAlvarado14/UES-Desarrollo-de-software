#include <iostream>
using namespace std;

int main()
{
    int NUMS;

    // Solicitar al usuario la cantidad de elementos del arreglo
    cout << "Ingrese la cantidad de elementos del arreglo: ";
    cin >> NUMS;

    // Crear un arreglo dinámico con el tamaño especificado
    int* nums = new int[NUMS];

    // Solicitar al usuario los valores del arreglo
    for (int i = 0; i < NUMS; i++) {
        cout << "Ingrese el valor para el elemento " << i + 1 << ": ";
        cin >> nums[i];
    }

    int total = 0, *nPt;

    nPt = nums;    // almacena la dirección de nums[0] en nPt
    for (int i = 0; i < NUMS; i++)
        total = total + *nPt++;
    cout << "El total de los elementos del arreglo es " << total << endl;

    // Liberar la memoria asignada dinámicamente
    delete[] nums;

    return 0;
}