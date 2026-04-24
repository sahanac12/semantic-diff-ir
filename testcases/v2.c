int compute(int *arr) {
    int sum = 0;
    for (int i = 0; i < n; i++)   // changed bound
        sum += arr[i];
    return sum;
}