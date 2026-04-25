float multiply(float *arr) {
    float result = 1.0f;
    for (int i = 0; i < 256; i++)
        result *= arr[i];
    return result;
}
