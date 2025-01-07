from django.urls import path
from .views import  BalanceView,AccountsView,TransferView

urlpatterns = [
    path('transfer/', TransferView.as_view(), name='transfer'),
    path('balance/<str:pk>', BalanceView.as_view(), name='balance'),
    path('accounts/', AccountsView.as_view(), name='accounts'),

]
