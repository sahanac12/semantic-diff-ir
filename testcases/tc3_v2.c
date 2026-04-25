double multiply(double *arr) {
    double result = 1.0;
    for (int i = 0; i < 256; i++)
        result *= arr[i];
    return result;
}
