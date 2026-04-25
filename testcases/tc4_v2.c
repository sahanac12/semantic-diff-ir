int search(int *arr, int size) {
    if (size <= 0) return 0;
    int sum = 0;
    for (int i = 0; i < size; i++)
        sum += arr[i];
    return sum;
}
