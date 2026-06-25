#include <iostream>
#include <string>

using namespace std;

// Structure to store product details
struct Product {
    string name;
    string description;
    double priceWithoutIVA;
    double IVA;
    double priceWithIVA;
};

// Function to calculate IVA
double calculateIVA(double price) {
    return price * 0.13;
}

// Function to calculate price with IVA
double calculatePriceWithIVA(double price, double IVA) {
    return price + IVA;
}

int main() {
    const int numProducts = 3; // Number of products
    Product products[numProducts] = {
        {"Laptop", "A high-performance laptop.", 1200.00, 0.0, 0.0},
        {"Smartphone", "Latest model smartphone.", 800.00, 0.0, 0.0},
        {"Headphones", "Noise-cancelling headphones.", 150.00, 0.0, 0.0}
    };

    // Calculate IVA and price with IVA for each product
    for (int i = 0; i < numProducts; ++i) {
        products[i].IVA = calculateIVA(products[i].priceWithoutIVA);
        products[i].priceWithIVA = calculatePriceWithIVA(products[i].priceWithoutIVA, products[i].IVA);
    }

    // Display product details
    cout << "\nProduct Details:\n";
    cout << "----------------------------------------\n";
    for (int i = 0; i < numProducts; ++i) {
        cout << "Product " << i + 1 << ":\n";
        cout << "Name: " << products[i].name << "\n";
        cout << "Description: " << products[i].description << "\n";
        cout << "Price without IVA: $" << products[i].priceWithoutIVA << "\n";
        cout << "IVA (13%): $" << products[i].IVA << "\n";
        cout << "Price with IVA: $" << products[i].priceWithIVA << "\n";
        cout << "----------------------------------------\n";
    }

    return 0;
}
