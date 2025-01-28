from django.urls import path
from .views import AccountsView,TransferView,TransactionListView,RegisterView, LoginView

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('transfer/', TransferView.as_view(), name='transfer'),
    path('accounts/', AccountsView.as_view(), name='accounts'),
    path('transactions/<str:address>/', TransactionListView.as_view(), name='transactions'),


]
