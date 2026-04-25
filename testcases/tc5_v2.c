int stride(int *arr) {
    int sum = 0;
    for (int i = 0; i < 1024; i += 2)
        sum += arr[i];
    return sum;
}
