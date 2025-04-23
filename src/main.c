#include <ntddk.h>

extern void Unload(PDRIVER_OBJECT DriverObject);
NTSTATUS DriverEntry(PDRIVER_OBJECT DriverObject, PUNICODE_STRING RegistryPath) {
    UNREFERENCED_PARAMETER(RegistryPath);
    DbgPrint("Hello from MyXPDriver!\n");
    DriverObject->DriverUnload = Unload;

    return STATUS_SUCCESS;
}
