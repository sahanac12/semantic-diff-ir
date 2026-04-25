int process(int *arr) {
    int sum = 0;
    for (int i = 0; i < 512; i++)
        sum += arr[i];
    return sum;
}
