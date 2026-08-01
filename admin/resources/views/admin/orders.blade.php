@extends('admin.layouts.app')

@section('content')
<div class="stats-grid">
    <div class="stat-card">
        <h3>Total Orders</h3>
        <div class="value">{{ $orderStats['total'] }}</div>
        <div class="hint">All orders placed</div>
    </div>
    <div class="stat-card">
        <h3>Successful</h3>
        <div class="value" style="color:var(--green)">{{ $orderStats['successful'] }}</div>
        <div class="hint">Payment completed</div>
    </div>
    <div class="stat-card">
        <h3>Pending</h3>
        <div class="value" style="color:var(--orange)">{{ $orderStats['pending'] }}</div>
        <div class="hint">Awaiting payment</div>
    </div>
    <div class="stat-card">
        <h3>Revenue</h3>
        <div class="value">₹{{ number_format($orderStats['revenue']) }}</div>
        <div class="hint">From successful orders</div>
    </div>
</div>

<div class="panel">
    <div class="panel-head">
        <h3>All Orders</h3>
        <span>{{ $orderStats['successful'] }} successful out of {{ $orderStats['total'] }}</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>User</th>
                <th>Product</th>
                <th>Qty</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($orders as $order)
                <tr>
                    <td><strong>{{ $order['order_id'] }}</strong></td>
                    <td>{{ $order['user'] }}</td>
                    <td>{{ $order['product'] }}</td>
                    <td>{{ $order['qty'] }}</td>
                    <td>₹{{ number_format($order['amount']) }}</td>
                    <td>{{ $order['date'] }}</td>
                    <td>
                        @php
                            $badge = match ($order['status']) {
                                'Success' => 'badge-green',
                                'Pending' => 'badge-orange',
                                default => 'badge-gray',
                            };
                        @endphp
                        <span class="badge {{ $badge }}">{{ $order['status'] }}</span>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
